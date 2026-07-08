# Convert a curl command (e.g. copied from browser dev tools) into a nushell
# `http <method>` call.
#
# Two modes:
#   - default (run mode): execute the request immediately and return the parsed
#     response. Useful in an interactive shell: `let x = cn`.
#   - --paste / -p: write the converted nushell command to the clipboard so it
#     can be pasted into the terminal. Handy from a launcher like vicinae.
#
# Reads the curl command from the clipboard via the `cb` helper.
export def curl-to-http [
  --paste (-p) # Convert and copy the nushell command to the clipboard instead of executing it
  --print # Print the converted nushell command to stdout (do not execute, do not touch clipboard)
  --raw (-r) # When executing, return body as raw text rather than parsed
  --full (-f) # When executing, return the full response (status, headers, body)
] {
  let clip = (cb | str trim)
  if ($clip | is-empty) {
    error make {msg: "Clipboard is empty"}
  }
  if not ($clip | str starts-with "curl") {
    error make {msg: $"Clipboard does not start with 'curl': (($clip | str substring 0..40))..."}
  }

  let tokens = tokenize $clip
  let parsed = parse-curl $tokens
  mut cmd = build-command $parsed
  if $raw {
    $cmd = ($cmd | str replace $"http ($parsed.method)" $"http ($parsed.method) --raw")
  }
  if $full {
    $cmd = ($cmd | str replace $"http ($parsed.method)" $"http ($parsed.method) --full")
  }

  if $print {
    print $cmd
    return
  }

  if $paste {
    $cmd | cb
    print $"Copied to clipboard:\n($cmd)"
    return
  }

  # Run mode: execute via a subshell and re-import the result as structured data.
  ^nu --no-config-file -c $"($cmd) | to nuon --raw" | from nuon
}

# Short alias for the main command.
export alias ":cn" = curl-to-http

# Tokenize a curl command line, honoring single-quoted strings with the
# `'\''` -> literal `'` convention that browser dev tools emit. Backslash
# line continuations are joined into spaces before tokenization.
def tokenize [s: string]: nothing -> list<string> {
  let normalized = ($s | str replace --all --regex '\\\s*\r?\n\s*' ' ')
  let chars = ($normalized | split chars)
  let n = ($chars | length)
  mut tokens = []
  mut buf = ""
  mut in_single = false
  mut in_double = false
  mut started = false
  mut i = 0
  while $i < $n {
    let c = ($chars | get $i)
    if $in_single {
      if $c == "'" {
        # Browser curl encodes a literal ' as '\'' — that is: close quote,
        # backslash-escaped quote outside quotes, then reopen quote. Detect
        # the full 4-character sequence and stay inside the single-quoted
        # string with a literal ' appended.
        if ($i + 3) < $n and (($chars | get ($i + 1)) == '\') and (($chars | get ($i + 2)) == "'") and (($chars | get ($i + 3)) == "'") {
          $buf = $buf + "'"
          $i = $i + 4
        } else {
          $in_single = false
          $i = $i + 1
        }
      } else {
        $buf = $buf + $c
        $i = $i + 1
      }
    } else if $in_double {
      if $c == '"' {
        $in_double = false
        $i = $i + 1
      } else if $c == '\' and ($i + 1) < $n {
        $buf = $buf + ($chars | get ($i + 1))
        $i = $i + 2
      } else {
        $buf = $buf + $c
        $i = $i + 1
      }
    } else {
      if $c == "'" {
        $in_single = true
        $started = true
        $i = $i + 1
      } else if $c == '"' {
        $in_double = true
        $started = true
        $i = $i + 1
      } else if $c in [' ' "\t" "\n" "\r"] {
        if $started {
          $tokens = $tokens ++ [$buf]
          $buf = ""
          $started = false
        }
        $i = $i + 1
      } else if $c == '\' and ($i + 1) < $n {
        # Bare backslash escape (e.g. \&). Take the next char literally.
        $buf = $buf + ($chars | get ($i + 1))
        $started = true
        $i = $i + 2
      } else {
        $buf = $buf + $c
        $started = true
        $i = $i + 1
      }
    }
  }
  if $started {
    $tokens = $tokens ++ [$buf]
  }
  $tokens
}

# Flags that take an argument we care about
const ARG_FLAGS_KEEP = ['-H' '--header' '-X' '--request' '-d' '--data' '--data-raw' '--data-binary' '--data-ascii' '--data-urlencode' '-u' '--user' '-A' '--user-agent' '-e' '--referer' '-b' '--cookie']
# Flags that take an argument but we silently drop
const ARG_FLAGS_DROP = ['--output' '-o' '--proxy' '-x' '--cacert' '--cert' '--key' '--connect-timeout' '--max-time' '-m' '--resolve' '--retry' '--form' '-F']
# Boolean flags we silently drop
const BOOL_FLAGS_DROP = ['--compressed' '-i' '--include' '-L' '--location' '-s' '--silent' '-S' '--show-error' '-v' '--verbose' '-k' '--insecure' '-O' '--remote-name' '-#' '--progress-bar' '--fail' '-f']

def parse-curl [tokens: list<string>] {
  mut headers = []
  mut method: string = ""
  mut url: string = ""
  mut body: string = ""
  mut i = 0
  let n = ($tokens | length)
  if $n == 0 or ($tokens | get 0) != "curl" {
    error make {msg: "Clipboard does not contain a curl command"}
  }
  $i = 1
  while $i < $n {
    let t = ($tokens | get $i)
    if $t in $ARG_FLAGS_KEEP {
      if ($i + 1) >= $n {
        $i = $i + 1
        continue
      }
      let v = ($tokens | get ($i + 1))
      if $t == '-H' or $t == '--header' {
        let parsed = ($v | parse --regex '^(?P<name>[^:]+):\s*(?P<value>.*)$' | get 0?)
        if ($parsed | is-not-empty) {
          $headers = $headers ++ [{name: ($parsed.name | str trim) value: ($parsed.value | str trim)}]
        }
      } else if $t == '-X' or $t == '--request' {
        $method = ($v | str lowercase)
      } else if $t in ['-d' '--data' '--data-raw' '--data-binary' '--data-ascii' '--data-urlencode'] {
        if ($body | is-empty) {
          $body = $v
        } else {
          $body = $body + "&" + $v
        }
      } else if $t == '-u' or $t == '--user' {
        # username:password -> Basic auth header
        $headers = $headers ++ [{name: "_curl_user_" value: $v}]
      } else if $t == '-A' or $t == '--user-agent' {
        $headers = $headers ++ [{name: "User-Agent" value: $v}]
      } else if $t == '-e' or $t == '--referer' {
        $headers = $headers ++ [{name: "Referer" value: $v}]
      } else if $t == '-b' or $t == '--cookie' {
        $headers = $headers ++ [{name: "Cookie" value: $v}]
      }
      $i = $i + 2
    } else if $t in $ARG_FLAGS_DROP {
      $i = $i + 2
    } else if $t in $BOOL_FLAGS_DROP {
      $i = $i + 1
    } else if ($t | str starts-with "-") and $t != "-" {
      # Unknown flag; assume boolean to be safe.
      $i = $i + 1
    } else {
      # Positional => URL (take the first one)
      if ($url | is-empty) {
        $url = $t
      }
      $i = $i + 1
    }
  }
  if ($url | is-empty) {
    error make {msg: "Could not find a URL in the curl command"}
  }
  if ($method | is-empty) {
    $method = if ($body | is-not-empty) { "post" } else { "get" }
  }
  {method: $method url: $url headers: $headers body: $body}
}

# Escape a string for use as a nushell double-quoted string literal.
def nu-quote [s: string]: nothing -> string {
  let escaped = (
    $s
    | str replace --all '\' '\\'
    | str replace --all '"' '\"'
  )
  '"' + $escaped + '"'
}

def build-command [parsed: record]: nothing -> string {
  let method = $parsed.method
  let headers = $parsed.headers
  # Extract user (basic auth) and content-type separately.
  let user_record = ($headers | where {|h| $h.name == "_curl_user_" } | get 0?)
  let real_headers = ($headers | where {|h| $h.name != "_curl_user_" })
  let content_type = (
    $real_headers
    | where {|h| ($h.name | str lowercase) == "content-type" }
    | get 0?.value
  )
  let header_headers = (
    $real_headers
    | where {|h| ($h.name | str lowercase) != "content-type" }
  )

  mut parts = [$"http ($method)"]

  if ($user_record | is-not-empty) {
    let parts2 = ($user_record.value | split row --regex ':' --number 2)
    let user = ($parts2 | get 0? | default "")
    let pass = ($parts2 | get 1? | default "")
    $parts = $parts ++ [$"--user (nu-quote $user)"]
    if ($pass | is-not-empty) {
      $parts = $parts ++ [$"--password (nu-quote $pass)"]
    }
  }

  if ($method in ['post' 'put' 'patch']) and ($content_type | is-not-empty) {
    $parts = $parts ++ [$"--content-type (nu-quote $content_type)"]
  }

  if ($header_headers | length) > 0 {
    let items = (
      $header_headers
      | each {|h| (nu-quote $h.name) + " " + (nu-quote $h.value) }
      | str join " "
    )
    $parts = $parts ++ [$"--headers [($items)]"]
  }

  $parts = $parts ++ [(nu-quote $parsed.url)]

  if ($method in ['post' 'put' 'patch']) and ($parsed.body | is-not-empty) {
    $parts = $parts ++ [(nu-quote $parsed.body)]
  }

  $parts | str join " "
}
