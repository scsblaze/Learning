from CommonClient import CommonContext, get_client_type
from NetUtils import ClientCommandProcessor

class FF7CommandProcessor(ClientCommandProcessor):
    def __init__(self, ctx):
        super().__init__(ctx)

class FF7Context(CommonContext):
    command_processor = FF7CommandProcessor
    game = "Final Fantasy VII"
    items_handling = 0b111

    async def server_auth(self, password):
        await self.send_connect()

get_client_type("Final Fantasy VII", lambda: FF7Context)
