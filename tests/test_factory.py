import pytest
import random
import string
from brownie import interface


@pytest.fixture(scope="module", autouse=True)
def factory(Factory, accounts):
    t = accounts[0].deploy(Factory)
    yield t


@pytest.fixture(scope="module", autouse=True)
def sketch(Sketch, accounts):
    t = accounts[0].deploy(Sketch)
    yield t


# def test_deploy_factory(factory, accounts):
#     assert factory == accounts

# def test_deploy_sketch(sketch, accounts):
#     assert sketch == accounts   

def test_start_sketch(sketch):
    sketch.startSketch("ipfs:///bafyreichzhlqfew2prvc6hpx2ug5lxn25sfwutwlx3iby64r46ztl2wgme/metadata.json")

def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))

@pytest.mark.require_network("polygon-main-fork-alchemy")
def test_create(sketch, accounts):
    id = id_generator(3)
    name = id + "N";
    symbol = id + "S";
    tx = sketch.create(name, symbol, 51, [accounts[0]], [1])
    dao = interface.IDao(tx.return_value)
    assert name == dao.name()
    assert symbol == dao.symbol()

