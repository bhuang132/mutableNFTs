pragma solidity >=0.6.0 <0.7.0;
//SPDX-License-Identifier: MIT

//import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract YourCollectible is ERC721 {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string ev_one = "QmbiAuGLWRk3hwdCSw8NNsPvm5cNoSbCY9XGi4TCQCa1Bc";
  string ev_two = "QmfHQ1zrDFrpJ1mJbxEqy5AJsMX86N3omcUGST1aQGk3KE";
  string ev_three = "QmVYnWz7vcn5Eh6hJAp5cxMtdEM6G4QdKqWenxfRbtXwvA";

  mapping (uint256 => uint256) private ev_state;
  mapping (uint256 => uint) private block_times;


  constructor() public ERC721("YourCollectible", "YCB") {
    _setBaseURI("https://ipfs.io/ipfs/");
  }

  function mintItem(address to, string memory tokenURI) public returns (uint256)
  {
      _tokenIds.increment();

      uint256 id = _tokenIds.current();
      _mint(to, id);
      _setTokenURI(id, ev_one);
      ev_state[id] = 0;
      block_times[id] = block.timestamp;
 
      return id;
  }

  function evolve(uint256 id) public{
    if(block.timestamp >= block_times[id] + 1 minutes){
      if(ev_state[id] == 0){
        ev_state[id] = 1;
        _setTokenURI(id, ev_two);
      }else if(ev_state[id] == 1){
        ev_state[id] = 2;
        _setTokenURI(id, ev_three);
      }else{
        revert("Max Evolution");
      }
    }else{
      revert("At least 1 minute must pass before you can evolve");
    }
  }

  function getBlockMinted(uint256 id) public returns (uint){
    return block_times[id];
  }

  function badTransfer(address from, address to, uint256 id) public{
    if(ev_state[id] == 1){
      ev_state[id] = 0;
      _setTokenURI(id, ev_one);
    }else if(ev_state[id] == 2){
       ev_state[id] = 1;
      _setTokenURI(id, ev_two);
    }
    transferFrom(from, to, id);
  }

  function getEvState(uint256 id) public returns (uint256){
    return ev_state[id];
  }



}
