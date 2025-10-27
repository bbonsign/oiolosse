import json

from kittens.tui.handler import result_handler
from kitty.boss import Boss


def main(args: list[str]) -> str:
    pass


@result_handler(no_ui=True)
def handle_result(
    args: list[str],
    answer: str,
    target_window_id: int,
    boss: Boss,
) -> None:
    w = boss.window_id_map.get(target_window_id)
    name = json.dumps(list(boss.all_loaded_session_names))
    if w is not None:
        w.paste(name)
