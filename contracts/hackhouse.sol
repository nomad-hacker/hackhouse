// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HackerHouses {

    struct Member {
        address memberAddress;
        bool exists;
    }

    struct HackerHouse {
        address owner;
        mapping(address => Member) members;
    }

    mapping(uint256 => HackerHouse) public hackerHouses;
    uint256 public nextHouseId = 1;

    event HackerHouseCreated(uint256 indexed houseId, address indexed owner, address[] initialMembers);
    event MembersAdded(uint256 indexed houseId, address[] memberAddresses);
    event MembersRemoved(uint256 indexed houseId, address[] memberAddresses);

    modifier isOwnerOf(uint256 houseId) {
        require(hackerHouses[houseId].owner == msg.sender, "Only owner of the HackerHouse can call this function");
        _;
    }

    function createHackerHouse(address[] memory initialMembers) external {
        hackerHouses[nextHouseId].owner = msg.sender;
        for(uint256 i = 0; i < initialMembers.length; i++) {
            hackerHouses[nextHouseId].members[initialMembers[i]] = Member(initialMembers[i], true);
        }
        emit HackerHouseCreated(nextHouseId, msg.sender, initialMembers);
        nextHouseId++;
    }

    function addMembers(uint256 houseId, address[] memory memberAddresses) external isOwnerOf(houseId) {
        for(uint256 i = 0; i < memberAddresses.length; i++) {
            require(!hackerHouses[houseId].members[memberAddresses[i]].exists, "Member already exists");

            hackerHouses[houseId].members[memberAddresses[i]] = Member(memberAddresses[i], true);
        }
        emit MembersAdded(houseId, memberAddresses);
    }

    function removeMembers(uint256 houseId, address[] memory memberAddresses) external isOwnerOf(houseId) {
        for(uint256 i = 0; i < memberAddresses.length; i++) {
            require(hackerHouses[houseId].members[memberAddresses[i]].exists, "Member does not exist");

            delete hackerHouses[houseId].members[memberAddresses[i]];
        }
        emit MembersRemoved(houseId, memberAddresses);
    }

    function getMember(uint256 houseId, address _memberAddress) external view returns (address, bool) {
        Member memory member = hackerHouses[houseId].members[_memberAddress];
        return (member.memberAddress, member.exists);
    }
}
