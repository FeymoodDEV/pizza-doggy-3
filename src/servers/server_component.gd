@abstract
extends Resource
class_name ServerComponent
## Component to be used in a server; provides it stats

# Extend to different types ; RAM, cooler, security module... whatever comes to mind as relevant
# then create different .tres based on those types and we can list them in a menu.

var name : String
## Name of the component to be displayed
var recipe
## Resources required to synthesise this component
