pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

// define an interface to the CryptoKitties contract
contract KittyInterface{
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes);
}

contract ZombieFeeding is ZombieFactory {
  // this is the cryptoKitties eth address - removed to add a function (immutability)
  // address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  // initialize the interface with the ckAddress - changing to a declaration - old code in comments:
  // KittyInterface kittyContract = KittyInterface(ckAddress);
  KittyInterface kittyContract;  
  
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }
  
  // this function makes sure that there is a cooldown time before Zombie can feed again
  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  // this function checks to make sure that the timer hasn't elapsed
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
    return (_zombie.readyTime <= now);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){
      newDna = newDna - newDna % 100 + 99; // if kitty replace last 2 digits of DNA with 99
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
