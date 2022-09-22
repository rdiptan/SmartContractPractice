// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract cityPoll {
    struct City {
        string cityName;
        uint256 vote;
        //you can add city details if you want
    }

    mapping(uint256 => City) public cities; //mapping city Id with the City ctruct - cityId should be uint256
    mapping(address => bool) hasVoted; //mapping to check if the address/account has voted or not

    address public owner;
    uint256 public cityCount = 0; // number of city added

    constructor(string memory _cityName) {
        //TODO set contract caller as owner
        //TODO set some intitial cities.
        owner = msg.sender;
        cities[0].cityName = _cityName;
        cities[0].vote = 0;
    }

    function addCity(string memory _cityName) public {
        //  TODO: add city to the CityStruct
        require(owner == msg.sender, "Must be an owner");

        cities[cityCount].cityName = _cityName;

        cityCount++;
    }

    function vote(uint8 _cityId) public {
        //TODO Vote the selected city through cityID
        require(!hasVoted[msg.sender], "You have already voted");
        City storage VoteCity = cities[_cityId];
        VoteCity.vote++;
        hasVoted[msg.sender] = true;
    }

    function getCity(uint256 _cityId) public view returns (string memory) {
        // TODO get the city details through cityID
        return cities[_cityId].cityName;
    }

    function getVote(uint256 _cityId) public view returns (uint256) {
        // TODO get the vote of the city with its ID
        return cities[_cityId].vote;
    }
}
