# pragma version 0.4.0
# pragma enable-decimals
"""
@license MIT
@title A sample buy-me-a-coffee contract
@author You!
@notice This contract is for creating a sample funding contract
"""

# We'll learn a new way to do interfaces later...
interface AggregatorV3Interface:
    def decimals() -> uint8: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def getRoundData(roundId: uint80) -> (uint80, int256, uint256, uint256, uint80): view
    def latestRoundData() -> (uint80, int256, uint256, uint256, uint80): view

# minimum USD decimals: public(constant(decimal)) = 50.0
MINIMUM_USD: public(constant(uint256)) = 50 * (10**18)
PRECISION: constant(uint256) = 1 * (10**18)
OWNER: public(immutable(address))
funders: public(DynArray[address], 100)
address_to_amount_funded: public(HashMap[address, uint256])
price_feed: public(AggregatorV3Interface)

@deploy
def __init__(price_feed: address):
    self.price_feed = AggregatorV3Interface(price_feed)
    OWNER = msg.sender

@internal
def _only_owner():
    assert msg.sender == OWNER, "Not the contract owner!"

@external
@payable
def fund():
    usd_value_of_eth: uint256 = self.get_eth_to_usd_rate(self.price_feed, msg.value)
    assert usd_value_of_eth >= MINIMUM_USD, "You need to spend more ETH!!"
    self.address_to_amount_funded[msg.sender] += msg.value
    self.funders.append(msg.sender)

@external
def withdraw():
    self._only_owner()
    for funder: address in self.funders:
        self.address_to_amount_funded[funder] = 0
    self.funders = []
    send(OWNER, self.balance)

@internal
@view
def get_eth_to_usd_rate(price_feed: AggregatorV3Interface, eth_amount: uint256) -> uint256:
    # Check the conversion rate
    a: uint80 = 0
    b: int256 = 0
    c: uint256 = 0
    d: uint256 = 0
    e: uint80 = 0
    (a, b, c, d, e) = staticcall(price_feed.latestRoundData())
    # We know the price has 8 decimals, so we need to add 1 + eth_amount: uint256 = convert(int256, (10**18) * (b * (10**-8)))
    # return eth_amount: uint256 = convert(int256, price * eth_amount)
    price: int256 = 0

    return price: int256
