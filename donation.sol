// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OrganDonationSystem {

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    enum Organ { Kidney, Liver, Heart, Lung, Pancreas }

    struct Donor {
        uint id;
        string name;
        uint age;
        Organ organ;
        bool isAvailable;
        address wallet;
    }

    struct Recipient {
        uint id;
        string name;
        uint age;
        Organ requiredOrgan;
        bool isMatched;
        address wallet;
    }

    uint public donorCount = 0;
    uint public recipientCount = 0;

    mapping(uint => Donor) public donors;
    mapping(uint => Recipient) public recipients;

    event DonorRegistered(uint donorId, string name);
    event RecipientRegistered(uint recipientId, string name);
    event OrganMatched(uint donorId, uint recipientId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function registerDonor(string memory _name, uint _age, Organ _organ) public {
        donorCount++;
        donors[donorCount] = Donor(donorCount, _name, _age, _organ, true, msg.sender);
        emit DonorRegistered(donorCount, _name);
    }

    function registerRecipient(string memory _name, uint _age, Organ _organ) public {
        recipientCount++;
        recipients[recipientCount] = Recipient(recipientCount, _name, _age, _organ, false, msg.sender);
        emit RecipientRegistered(recipientCount, _name);
    }

    function matchOrgan(uint _donorId, uint _recipientId) public onlyAdmin {
        Donor storage donor = donors[_donorId];
        Recipient storage recipient = recipients[_recipientId];

        require(donor.isAvailable, "Donor organ not available");
        require(!recipient.isMatched, "Recipient already matched");
        require(donor.organ == recipient.requiredOrgan, "Organ types do not match");

        donor.isAvailable = false;
        recipient.isMatched = true;

        emit OrganMatched(_donorId, _recipientId);
    }

    function getDonorDetails(uint _id) public view returns (Donor memory) {
        return donors[_id];
    }

    function getRecipientDetails(uint _id) public view returns (Recipient memory) {
        return recipients[_id];
    }
}