// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract ParkingDots is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private reservationCounter;
    
    address private owner;

    struct Reservation {
        uint reservationId;
        address user;
        uint parkingSpotId;
        uint startTime;
        uint endTime;
        bool isActive;
    }

    mapping(uint => bool) private parkingSpots;
    mapping(uint => Reservation) private reservations;

    event ReservationMade(uint reservationId, address user, uint parkingSpotId, uint startTime, uint endTime);
    event ReservationCanceled(uint reservationId, address user, uint parkingSpotId);
    event ParkingSpotStateChanged(uint parkingSpotId, bool isOccupied);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function makeReservation(uint _parkingSpotId, uint _startTime, uint _endTime) public nonReentrant {
        require(!parkingSpots[_parkingSpotId], "Parking spot is already occupied.");
        require(_endTime > _startTime, "Invalid reservation times.");

        reservationCounter.increment();
        uint currentReservationId = reservationCounter.current();
        parkingSpots[_parkingSpotId] = true;
        reservations[currentReservationId] = Reservation(
            currentReservationId,
            msg.sender,
            _parkingSpotId,
            _startTime,
            _endTime,
            true
        );

        emit ReservationMade(currentReservationId, msg.sender, _parkingSpotId, _startTime, _endTime);
        emit ParkingSpotStateChanged(_parkingSpotId, true);
    }

    function cancelReservation(uint _reservationId) public nonReentrant {
        require(reservations[_reservationId].isActive, "Reservation is not active.");
        require(msg.sender == reservations[_reservationId].user, "Only the reservation owner can cancel.");
        uint parkingSpotId = reservations[_reservationId].parkingSpotId;
        parkingSpots[parkingSpotId] = false;
        reservations[_reservationId].isActive = false;

        emit ReservationCanceled(_reservationId, msg.sender, parkingSpotId);
        emit ParkingSpotStateChanged(parkingSpotId, false);
    }

    function getReservation(uint _reservationId) public view returns (Reservation memory) {
        return reservations[_reservationId];
    }

    function getParkingSpotStatus(uint _parkingSpotId) public view returns (bool) {
        return parkingSpots[_parkingSpotId];
    }
}
