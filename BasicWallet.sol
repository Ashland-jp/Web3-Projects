// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./PriceConverter.sol";

error NotOwner();
//constant, immutable

contract BasicWallet {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;
    
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable{
        //set minimum amount
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough!"); //1e18 == 1 + 10  
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }
    
    function withdraw() public onlyOwner {

        // starting index, end index/bool, increment or step amt
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the funders array
        funders = new address[](0);
       (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
       require(callSuccess, "Call Failed");
    }

    modifier onlyOwner {
        //require(msg.sender == i_owner, "Who Art Thou???");
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
    //what happens if i send this contract ETH without calling fund function? 
}
