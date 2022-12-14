import pytest
import random
import string
from brownie import interface
from eip712.messages import EIP712Message, EIP712Type


@pytest.fixture(scope="module", autouse=True)
def factory(Factory, accounts):
    t = accounts[0].deploy(Factory)
    yield t


@pytest.fixture(scope="module", autouse=True)
def sketch(Sketch, accounts):
    t = accounts[0].deploy(Sketch)
    yield t


def test_start_sketch(sketch):
    sketch.startSketch("ipfs:///bafyreichzhlqfew2prvc6hpx2ug5lxn25sfwutwlx3iby64r46ztl2wgme/metadata.json")


def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))


@pytest.mark.require_network("polygon-main-fork-alchemy")
def test_create(sketch, accounts):
    id = id_generator(3)
    name = id + "N"
    symbol = id + "S"
    tx = sketch.create(name, symbol, 51, [accounts[0]], [1])
    dao = interface.IDao(tx.return_value)
    assert name == dao.name()
    assert symbol == dao.symbol()


@pytest.mark.require_network("polygon-main-fork-alchemy")
def test_create_collab(factory, sketch, accounts, Collab, web3):
    local = accounts.add(private_key="0x416b8a7d9290502f5661da81f0cf43893e3d19cb9aea3c426cfb36e8186e9c09")
    accounts[0].transfer(local, 10)
    factory.setSketch(sketch)
    sketch.setFactory(factory)
    sketch_id = sketch.startSketch(
        "ipfs:///bafyreichzhlqfew2prvc6hpx2ug5lxn25sfwutwlx3iby64r46ztl2wgme/metadata.json",
        {"from": local}
    ).return_value

    collab_address, sign_message = factory.createCollab(sketch_id, "Name", 2, 2, {"from": local}).return_value

    assert sketch.ownerOf(sketch_id) == collab_address
    print("------------------------------------------------------------------------------------------------------")
    print("encodedAddPermittedData:")
    print(Collab.at(collab_address).encodedAddPermittedData())
    txhash = Collab.at(collab_address).txHash()
    print(f"txhash={txhash}")
    print(f"signer={local.address}")
    print(f"message={sign_message}")
    print(f"collab_address={collab_address}")
    signature = web3.eth.account.signHash(txhash, "0x416b8a7d9290502f5661da81f0cf43893e3d19cb9aea3c426cfb36e8186e9c09").signature
    print(f"signature={signature}")
    # Collab.at(collab_address).setupPermitted(signature, {"from": local})


@pytest.mark.require_network("polygon-main-fork-alchemy")
def test_evaluate_pieces(factory, sketch, accounts, Collab):
    local = accounts.add(private_key="0x416b8a7d9290502f5661da81f0cf43893e3d19cb9aea3c426cfb36e8186e9c09")
    factory.setSketch(sketch)
    sketch.setFactory(factory)
    sketch_id = sketch.startSketch(
        "ipfs:///bafyreichzhlqfew2prvc6hpx2ug5lxn25sfwutwlx3iby64r46ztl2wgme/metadata.json",
        {"from": local}
    ).return_value

    collab_address, sign_message = factory.createCollab(sketch_id, "Name", 2, 2, {"from": local}).return_value
    icollab = interface.ICollab(collab_address)
    icollab.evaluatePieces([3, 2, 1, 0], [3, 2, 1, 0], {"from": local})
    icollab.evaluatePieces([0, 1, 2, 3], [0, 1, 2, 3], {"from": local})
    print(f"collab_address={collab_address}")
    collab_contract = Collab.at(collab_address)
    # print("------------------------------------------------------------------------------------------------------")
    # print(collab_contract.pieces(0))
    # print(collab_contract.pieces(1))
    # print(collab_contract.pieces(2))
    # print(collab_contract.pieces(3))
    # print("------------------------------------------------------------------------------------------------------")
    assert [1, 1, 1, 1] == [
        collab_contract.pieces(0)[3],
        collab_contract.pieces(1)[3],
        collab_contract.pieces(2)[3],
        collab_contract.pieces(3)[3],
    ]
    assert [1, 1, 1, 1] == [
        collab_contract.pieces(0)[4],
        collab_contract.pieces(1)[4],
        collab_contract.pieces(2)[4],
        collab_contract.pieces(3)[4],
    ]
