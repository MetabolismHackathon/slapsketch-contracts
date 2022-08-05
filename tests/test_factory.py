import pytest
from brownie import accounts


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


@pytest.mark.require_network("polygon-main-fork")
def test_create(sketch):
    sketch.create("DAOName", "DAOSymbol", 51, [accounts[0]], [1])
