pragma solidity ^0.8.7;

contract CabChain {

   // data 
    address private manager;
    address[] public drivers;

    struct Trip {
        address passanger; // passanger registering a trip
        string from;  // from address
        string to; // destination address
        uint fare;   // current lowest fare
        address driver; // address of a driver with the smallest offer for the fair 
        bool complete;
    }

    mapping(uint => Trip) public trips;


    constructor() {
        manager = msg.sender;
    }

      // public 

    function getManager() public view returns(address) {
        return manager;
    }

    function registerDriver() public {
        drivers.push(msg.sender);
    }



    // gets minimum fare for specific trip
    function getCurrentFare(uint index) public view returns(uint) {
        return trips[index].fare;
    }

// drivers only 

    function proposeFare(uint index, uint propossedFare) public driverOnly(msg.sender) {
        require(trips[index].complete == false);
        if(trips[index].fare == 0 ||trips[index].fare > propossedFare){
            trips[index].fare = propossedFare;
            trips[index].driver = msg.sender;
        } else {
            revert();
        }
    }



    // modifiers 

    modifier passangerOnly(address sender) {
        require(filterArray(passangers, sender));
        _;
    }

    modifier driverOnly(address sender) {
        require(filterArray(drivers, sender));
        _;
    }

   

    // utils

    function filterArray(address[] memory array, address  sender) private returns(bool) {
        bool includes = false;
        for(uint i = 0; i < array.length; i++) {
            if(array[i] == sender){
                includes = true;
            }
        }
        return includes;
    }






}