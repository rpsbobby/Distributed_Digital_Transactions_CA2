pragma solidity ^0.8.7;

contract CabChain {

    // data 
    address private manager;
    address[] public drivers;
    address[] public passengers;
    uint private indexOfLastTrip = 0;

    struct Trip {
        address passenger; // passenger registering a trip
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

    function registerPassenger() public  {
        passengers.push(msg.sender);
    }

    function getIndexOfLastTripInArray() public view returns(uint) {
        return indexOfLastTrip - 1;
    }

    // gets minimum fare for specific trip
    function getCurrentFare(uint index) public view returns(uint) {
        return trips[index].fare;
    }

    // passengers only

    function addTrip(string memory from, string memory to) public passengerOnly(msg.sender) {
        trips[indexOfLastTrip] = Trip(msg.sender, from, to, 0, msg.sender, false);
        indexOfLastTrip++;
    }

    // accept fare

    // user needs to send fare cost with contract 
    function acceptFare(uint index) public payable passengerOnly(msg.sender) {
        Trip storage trip = trips[index];
        require(trip.complete == false);
        // require passenger address and person accepting to have the same address
        require(trip.passenger == msg.sender);
        // require fare amount to be send by the user
        require(trip.fare - 1 < uint248(msg.value));
        // wrap driver's address to be payable and accept ether
        address payable driver = payable(trip.driver);
        driver.transfer(msg.value);
        trip.complete = true;
        
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

    modifier passengerOnly(address sender) {
        require(filterArray(passengers, sender));
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