import subprocess
from libqtile import widget
from libqtile.command import lazy

class SystemdServiceWidget(widget.TextBox):
    def __init__(self, service_name, display_name, show_icon=False, **config):
        super().__init__("", **config)
        self.service_name = service_name
        self.display_name = display_name
        self.show_icon = show_icon
        self.active_state = "✓" if show_icon else "active"
        self.inactive_state = "✗" if show_icon else "inactive"
        self.add_callbacks({"Button1": self.toggle_service})

    def _configure(self, qtile, bar):
        super()._configure(qtile, bar)
        self.update_status()

    def update_status(self):
        status = self.get_service_status()
        self.text = f"{self.display_name}: {status}"
        self.bar.draw()

    def get_service_status(self):
        try:
            result = subprocess.run(["systemctl", "--user", "is-active", self.service_name], capture_output=True, text=True)
            return self.active_state if result.stdout.strip() == "active" else self.inactive_state
        except subprocess.CalledProcessError:
            return "Error"

    def toggle_service(self):
        status = self.get_service_status()
        action = "stop" if status == self.active_state else "start"
        subprocess.run(["systemctl", "--user", action, self.service_name])
        self.update_status()

