from brownie import Sketch, Factory, accounts, interface
# export POLYGONSCAN_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME
# brownie run scripts/deploy.py --network polygon-main
def main():
    deployer = accounts.load('polygon_deployer')
    sketchContract = Sketch.deploy(
        {'from': deployer},
        publish_source=True,
    )

    factoryContract = Factory.deploy(
        {'from': deployer},
        publish_source=True,
    )