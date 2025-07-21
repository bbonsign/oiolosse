import asyncio
import datetime

from ignis import utils, widgets
from ignis.app import IgnisApp
from ignis.menu_model import IgnisMenuItem, IgnisMenuModel, IgnisMenuSeparator
from ignis.services.audio import AudioService
from ignis.services.mpris import MprisPlayer, MprisService
from ignis.services.niri import NiriService, NiriWindow, NiriWorkspace

# from ignis.services.notifications import NotificationService
from ignis.services.system_tray import SystemTrayItem, SystemTrayService
from ignis.services.upower import UPowerService

app = IgnisApp.get_default()

app.apply_css(f"{utils.get_current_dir()}/styles.scss")


audio = AudioService.get_default()
system_tray = SystemTrayService.get_default()
niri = NiriService.get_default()
# notifications = NotificationService.get_default()
mpris = MprisService.get_default()
upower = UPowerService.get_default()

# NOTE: Browse system icons with nix via `, icon-library`


def workspace_button(workspace: NiriWorkspace) -> widgets.Button:
    # icons = {
    #     "browser": "",
    #     "term": "",
    #     "chat": "󰭹",
    # }
    icons = {}
    ws_widgets = widgets.Button(
        css_classes=["workspace"],
        on_click=lambda x: workspace.switch_to(),
        child=widgets.Label(label=str(icons.get(workspace.name, workspace.id))),
    )
    if workspace.is_active:
        ws_widgets.add_css_class("active")

    return ws_widgets


def scroll_workspaces(monitor_name: str, direction: str) -> None:
    current = list(
        filter(lambda w: w.is_active and w.output == monitor_name, niri.workspaces)
    )[0].idx
    if direction == "up":
        target = current + 1
        niri.switch_to_workspace(target)
    else:
        target = current - 1
        niri.switch_to_workspace(target)


def workspaces(monitor_name: str) -> widgets.EventBox:
    return widgets.EventBox(
        vertical=True,
        on_scroll_up=lambda x: scroll_workspaces("up", monitor_name),
        on_scroll_down=lambda x: scroll_workspaces("down", monitor_name),
        css_classes=["workspaces"],
        spacing=5,
        child=niri.bind(
            "workspaces",
            transform=lambda value: [
                workspace_button(i) for i in value if i.output == monitor_name
            ],
        ),
    )


def window_button(window: NiriWindow) -> widgets.Button:
    icon_name = (
        _icon_name
        if (_icon_name := utils.get_app_icon_name(window.app_id))
        else "image-missing-symbolic"
    )
    buttons = widgets.Button(
        css_classes=["window"],
        tooltip_text=f"{window.title} | {window.app_id}",
        on_click=lambda x: window.focus(),
        child=widgets.Icon(image=icon_name, pixel_size=16),
    )
    if window.is_focused:
        buttons.add_css_class("active")

    return buttons


def windows(monitor_name: str) -> widgets.EventBox:
    monitor_workspaces = [w.id for w in niri.workspaces if w.output == monitor_name]
    return widgets.EventBox(
        # on_scroll_up=lambda x: scroll_workspaces("up", monitor_name),
        # on_scroll_down=lambda x: scroll_workspaces("down", monitor_name),
        css_classes=[],
        spacing=5,
        child=niri.bind(
            "windows",
            transform=lambda value: [
                window_button(i) for i in value if i.workspace_id in monitor_workspaces
            ],
        ),
    )


def mpris_title(player: MprisPlayer) -> widgets.Box:
    return widgets.Box(
        spacing=10,
        setup=lambda self: player.connect(
            "closed",
            lambda x: self.unparent(),  # remove widgets when player is closed
        ),
        child=[
            widgets.Icon(image="audio-x-generic-symbolic"),
            widgets.Label(
                ellipsize="end",
                max_width_chars=20,
                label=player.bind("title"),
            ),
        ],
    )


def on_player_added(x, player: MprisPlayer, button):
    button.append(mpris_title(player))
    button.on_click = lambda x: player.play_pause()


def media() -> widgets.Box:
    return widgets.EventBox(
        # spacing=10,
        child=[
            widgets.Label(
                label="",
                visible=mpris.bind("players", lambda value: len(value) == 0),
            )
        ],
        setup=lambda self: mpris.connect(
            "player-added",
            lambda x, player: on_player_added(x, player, self),
        ),
    )


def active_window_title(monitor_name) -> widgets.Label:
    return widgets.Label(
        ellipsize="end",
        css_classes=["window_title"],
        max_width_chars=40,
        visible=niri.bind("active_output", lambda output: output == monitor_name),
        label=niri.active_window.bind("title"),
    )


def active_window_app_id(monitor_name) -> widgets.Label:
    return widgets.Label(
        ellipsize="end",
        css_classes=["window_title"],
        max_width_chars=40,
        visible=niri.bind("active_output", lambda output: output == monitor_name),
        label=niri.active_window.bind("app_id"),
    )


def active_window(monitor_name) -> widgets.Box:
    return widgets.Box(
        child=[
            active_window_title(monitor_name),
            widgets.Separator(
                vertical=True,
                css_classes=["middle-separator"],
            ),
            active_window_app_id(monitor_name),
        ],
        spacing=10,
    )


# def current_notification() -> widgets.Label:
#     return widgets.Label(
#         ellipsize="end",
#         max_width_chars=20,
#         label=notifications.bind(
#             "notifications", lambda value: value[-1].summary if len(value) > 0 else None
#         ),
#     )


def clock() -> widgets.Label:
    # poll for current time every second
    return widgets.Box(
        child=[
            widgets.Label(
                css_classes=["clock"],
                label=utils.Poll(
                    1_000,
                    lambda self: datetime.datetime.now().strftime("%Y %B %d  %H:%M"),
                ).bind("output"),
            ),
            widgets.Separator(
                vertical=True,
                css_classes=["middle-separator"],
            ),
            widgets.Label(
                css_classes=["clock"],
                label=utils.Poll(
                    1_000,
                    lambda self: datetime.datetime.now().strftime("%I:%M %p"),
                ).bind("output"),
            ),
            widgets.Separator(
                vertical=True,
                css_classes=["middle-separator"],
            ),
            widgets.Label(
                css_classes=["clock"],
                label=utils.Poll(
                    1_000,
                    lambda self: datetime.datetime.now(datetime.timezone.utc).strftime(
                        "UTC %H:%M"
                    ),
                ).bind("output"),
            ),
        ],
        spacing=10,
    )


def battery() -> widgets.Label:
    # poll for current time every second
    return widgets.Box(
        child=[
            widgets.Label(
                label=utils.Poll(
                    10_000, lambda self: f"{int(upower.batteries[0].percent)}%"
                ).bind("output"),
            ),
            widgets.Button(
                on_click=lambda x: utils.exec_sh("~/.local/bin/power-profiles.nu"),
                child=widgets.Icon(
                    image=upower.batteries[0].bind("icon_name"),
                    style="margin-right: 2px;",
                ),
            ),
        ]
    )


def microphone() -> widgets.Box:
    return widgets.Box(
        child=[
            widgets.Button(
                on_click=lambda x: utils.exec_sh(
                    "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                ),
                child=widgets.Icon(
                    image=audio.microphone.bind("icon_name"),
                    style="margin-right: 5px;",
                ),
            ),
            widgets.Label(
                label=audio.microphone.bind(
                    "volume",
                    transform=lambda value: str(value),
                )
            ),
        ]
    )


def volume() -> widgets.Box:
    return widgets.Box(
        child=[
            widgets.Button(
                on_click=lambda x: utils.exec_sh(
                    "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ),
                child=widgets.Icon(
                    image=audio.speaker.bind("icon_name"), style="margin-right: 5px;"
                ),
            ),
            widgets.Label(
                label=audio.speaker.bind("volume", transform=lambda value: str(value))
            ),
        ]
    )


def tray_item(item: SystemTrayItem) -> widgets.Button:
    if item.menu:
        menu = item.menu.copy()
    else:
        menu = None

    return widgets.Button(
        child=widgets.Box(
            child=[
                widgets.Icon(image=item.bind("icon"), pixel_size=16),
                menu,
            ]
        ),
        setup=lambda self: item.connect("removed", lambda x: self.unparent()),
        tooltip_text=item.bind("tooltip"),
        on_click=lambda x: menu.popup() if menu else None,
        on_right_click=lambda x: menu.popup() if menu else None,
        css_classes=["tray-item"],
    )


def tray():
    return widgets.Box(
        css_classes=["tray"],
        setup=lambda self: system_tray.connect(
            "added",
            lambda x, item: self.append(tray_item(item)),
        ),
        spacing=10,
    )


def volume_slider() -> widgets.Scale:
    return widgets.Scale(
        min=0,
        max=100,
        step=1,
        value=audio.speaker.bind("volume"),
        on_change=lambda x: audio.speaker.set_volume(x.value),
        css_classes=["volume-slider"],  # we will customize style in style.css
    )


def create_exec_task(cmd: str) -> None:
    # use create_task to run async function in a regular (sync) one
    asyncio.create_task(utils.exec_sh_async(cmd))


def logout() -> None:
    create_exec_task("niri msg action quit")


def swaync():
    return widgets.Button(
        child=widgets.Box(
            child=[
                widgets.Icon(
                    image="system-shutdown-symbolic",
                    pixel_size=16,
                ),
                menu,
            ]
        ),
        on_click=lambda x: menu.popup(),
    )


def power_menu() -> widgets.Button:
    menu = widgets.PopoverMenu(
        model=IgnisMenuModel(
            IgnisMenuItem(
                label="Lock",
                on_activate=lambda x: create_exec_task("swaylock"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Suspend",
                on_activate=lambda x: create_exec_task("systemctl suspend"),
            ),
            IgnisMenuItem(
                label="Hibernate",
                on_activate=lambda x: create_exec_task("systemctl hibernate"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Reboot",
                on_activate=lambda x: create_exec_task("systemctl reboot"),
            ),
            IgnisMenuItem(
                label="Shutdown",
                on_activate=lambda x: create_exec_task("systemctl poweroff"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Logout",
                enabled=niri.is_available,
                on_activate=lambda x: logout(),
            ),
        ),
    )
    return widgets.Button(
        child=widgets.Box(
            child=[
                widgets.Icon(
                    image="system-shutdown-symbolic",
                    pixel_size=16,
                ),
                menu,
            ]
        ),
        on_click=lambda x: menu.popup(),
    )


def left(monitor_name: str) -> widgets.Box:
    return widgets.Box(
        child=[
            windows(monitor_name),
            # active_window(monitor_name),
        ],
        spacing=10,
    )


def center() -> widgets.Box:
    return widgets.Box(
        child=[
            clock(),
            # widgets.Separator(
            #     vertical=True,
            #     css_classes=["middle-separator"],
            #     visible=mpris.bind("players", lambda value: len(value) > 0),
            # ),
            # media(),
        ],
        spacing=10,
    )


def right() -> widgets.Box:
    return widgets.Box(
        child=[
            tray(),
            microphone(),
            volume(),
            volume_slider(),
            battery(),
            power_menu(),
        ],
        spacing=10,
    )


def bar(monitor_id: int = 0) -> widgets.Window:
    monitor_name = utils.get_monitor(monitor_id).get_connector()  # type: ignore
    return widgets.Window(
        namespace=f"ignis_bar_{monitor_id}",
        monitor=monitor_id,
        anchor=["left", "bottom", "right"],
        exclusivity="exclusive",
        child=widgets.CenterBox(
            css_classes=["bar"],
            start_widget=left(monitor_name),  # type: ignore
            center_widget=center(),
            end_widget=right(),
        ),
    )


def bar2(monitor_id: int = 0) -> widgets.Window:
    monitor_name = utils.get_monitor(monitor_id).get_connector()  # type: ignore
    return widgets.Window(
        namespace=f"ignis_bar2_{monitor_id}",
        monitor=monitor_id,
        anchor=["top", "left", "bottom"],
        exclusivity="exclusive",
        layer="top",
        child=widgets.CenterBox(
            vertical=True,
            css_classes=["bar2"],
            start_widget=widgets.Box(
                child=[],
            ),
            center_widget=widgets.Box(
                child=[],
            ),
            end_widget=widgets.Box(
                child=[
                    workspaces(monitor_name),
                ],
            ),
        ),
    )


# this will display bar on all monitors
for i in range(utils.get_n_monitors()):
    bar(i)
    bar2(i)
