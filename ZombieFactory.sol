pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna); // event handler

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits; // 10^16 = 1e16 = the length of dnaDigits

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies; // create new array

    mapping (uint => address) public zombieToOwner; // zombieToOwner[uint] returns address
    mapping (address => uint) ownerZombieCount; // ownerZombieCount[address] returns uint

    function _createZombie(string memory _name, uint _dna) internal {
        // make this function internal instead of private so inherited functions can access
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender; // assign address the value of msg.sender which is the current user
        ownerZombieCount[msg.sender]++; // increment uint by 1
        emit NewZombie(id, _name, _dna); // send to event handler
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str))); // hash id of string value using keccak256
        return rand % dnaModulus; // make sure that the value returned is only dnaDigits long
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0); // make sure only one zombie per person, or person can't create more than one
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
