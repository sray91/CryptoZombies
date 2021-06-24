pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]); // make sure current user is the owner
    Zombie storage myZombie = zombies[_zombieId]; // assign local myZombie to storage (on the blockchain)
    _targetDna = _targetDna % dnaModulus; // make sure that _targetDna isn't longer than 16 digits
    uint newDna = (myZombie.dna + _targetDna) / 2; // take the average using the .dna from the struct
    _createZombie("NoName", newDna); // create a new Zombie with name NoName
  }
}
