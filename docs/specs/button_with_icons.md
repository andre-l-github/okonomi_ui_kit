Extend button components (ui.link_to, ui.button_to, ui.button_tag, FormBuilder#submit) to accept an icon argument, e.g.:

```erb
<%= ui.button_tag "Download", variant: :contained, color: :primary, icon: "heroicons/outline/user" %>
```

Or:

```erb
<%= ui.button_tag "Download", variant: :contained, color: :primary, icon: { start: "heroicons/outline/user" } %>
```

or

```erb
<%= ui.button_tag "Download", variant: :contained, color: :primary, icon: { end: "heroicons/outline/user" } %>
```

=> if not position provided (only the icon path), default to `start`.