from BaseClasses import Item, ItemClassification

# ToDo - Fill out table with items, Start with Prog > Useful > Etc
#item_table = {
#    "Keystone": ItemClassification.PROGRESSION,
#    "Buggy": ItemClassification.PROGRESSION,
#    "Chocobo Lure": ItemClassification.USEFUL,
# ...
#}

def create_ff7_item(name: str, player: int) -> Item:
    return Item(name, item_table[name], None, player)
