Please refactor legacy code $ARGUMENTS to become a proper component.

Follow the guidelines from `docs/COMPONENT_GUIDE.md`.

* Ensure the component is self-contained
* Ensure well defined tests
* Extract styles into dedicated block
* Update all places where the old implementation was used to use the new component
* create a user guide under `guides/components/<component_name>.md`, link it from `README.md`
* create a migration guid under `guides/migrations/<component_name>.md`, do not link it from `README.md`
* Ensure $ARGUMENTS has been removed
* Ensure all tests pass