pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
  
  uint levelUpFee = 0.001 ether;

  // includes a modifier that uses the zombie level property to restrict access to special abilities
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level); // greater than or equal to
    _;
  }
  
  // use payable to require payment for a level up
  function levelUp(uint _zombieId) external payable {
     require(msg.value == levelUpFee);
     zombies[_zombieId].level++; // increment zombie level
  }
  
  // only a level 2 can change the name
  function changeName(uint _zombieId, string calldata_newName) external aboveLevel(2, _zombieId){
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }
  // only a level 20 can change the DNA
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId){
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }
  // external view functions do not cost any gas
  // for loop that iterates through all the zombies in our DApp, 
  // compares their owner to see if we have a match, and pushes them to our result array before returning it.
  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++){ 
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }
}
