from csv import DictReader
from urllib.parse import urlsplit, parse_qs

import re
import subprocess as sp
import sys


# Based on gcalcli output names
class Event:
    def __init__(
        self, title, start_time, end_time, html_link, conference_uri, location, **kwargs
    ):
        self.title = title
        self.duration = f"{start_time} - {end_time}"
        self.cal_link = html_link
        self.zoom = self.zoom_to_uri(conference_uri) or self.zoom_to_uri(location)

    @staticmethod
    def zoom_to_uri(url):
        """Converts a possible Zoom URL to the corresponding app URI"""
        if not url:
            return url
        parsed_url = urlsplit(url)

        domain = parsed_url.netloc
        if "zoom" not in domain:
            return None

        room_match = re.match(r"\/j\/([a-zA-Z0-9]+)", parsed_url.path)
        if room_match is None:
            return None  # Couldn't find zoom room, maybe invalid url?
        room = f"&confno={room_match.group(1)}"

        pwd = parse_qs(parsed_url.query).get("pwd")
        pwd = f"&pwd={pwd[0]}" if pwd else ""

        return f"zoommtg://{domain}/join?action=join{room}{pwd}"


def build_notify_cmd(title, body, actions=None, error=False, mute=False):
    actions = {} if actions is None else actions

    app = "Calendar"
    icon = "view-calendar-upcoming-events" if not error else "dialog-warning"
    sound = "dialog-question" if not error else "dialog-warning"

    style = f"-i {icon} {f'-h string:sound-name:{sound}' if not mute else ''}"
    action_str = " ".join(f"-A '{action}={name}'" for name, action in actions.items())
    title = title.replace('"', '\\"')
    body = body.replace('"', '\\"')

    # Note: While timeout does affect display duration, notify-send also exits at the
    # end of the duration without a STDOUT output. No timeout is thus used to maintain
    # the action button functionality after the desktop environment's default display.
    return f'notify-send -a {app} {style} {action_str} "{title}" "{body}"'


gcalcli_details = "--details url --details conference --details location"
gcalcli_limits = "now 5mins"
gcalcli = f"gcalcli agenda {gcalcli_details} --nostarted --tsv {gcalcli_limits}"

try:
    agenda_str = sp.check_output(gcalcli.split(" "), text=True).split("\n")
except sp.CalledProcessError as e:
    sp.run(build_notify_cmd("Failed to call gcalcli", str(e), error=True), shell=True)
    sys.exit(1)

event_dicts = DictReader(agenda_str, delimiter="\t")
events = [Event(**event_dict) for event_dict in event_dicts]

for i, e in enumerate(events):
    # notify-send uses equals as a separator so have to temporarily replace it
    actions = {"Open Zoom": e.zoom.replace("=", "%3D")} if e.zoom else {}
    actions["Open Event"] = e.cal_link.replace("=", "%3D")

    notify = build_notify_cmd(e.title, e.duration, actions, mute=i > 0)

    sed = "sed -e 's/%3D/=/g'"  # Reverse the equals replacement
    xdg_open = "xargs --no-run-if-empty xdg-open"

    sp.Popen(f"{notify} | {sed} | {xdg_open}", shell=True)  # Popen so non-blocking
