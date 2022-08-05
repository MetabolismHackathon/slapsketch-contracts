from brownie import Sketch, Factory, accounts, interface
# export POLYGONSCAN_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME
# brownie run scripts/deploy.py --network polygon-main
def main():
    sketchContract = Sketch.deploy(
        publish_source=True,
    )

    factoryContract = Factory.deploy(
        publish_source=True,
    )