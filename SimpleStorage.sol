// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;


//EVM
//avalanche,fantom,polygon
contract SimpleStorage {        //types=boolean, uint, int, address, bytes
    
        // uint gets initialized to 0!
    uint256 public favoriteNumber;
    
    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }
    
    People[] public people;

    function store(uint256 _favoriteNumber) public virtual{
        favoriteNumber = _favoriteNumber; 

    }
    //view,pure
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    //calldata, memory and storage
    function addPerson(string memory _name, uint256 _favoriteNumber) public {

        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
