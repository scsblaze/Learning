from BaseClasses import Item, ItemClassification

item_table = {
    "Keystone": ItemClassification.PROGRESSION,
    "Buggy": ItemClassification.PROGRESSION,
    "Chocobo Lure": ItemClassification.USEFUL,
    "Potion": ItemClassification.FOLDER,
}

def create_ff7_item(name: str, player: int) -> Item:
    return Item(name, item_table[name], None, player)
