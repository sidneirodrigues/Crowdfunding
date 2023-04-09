// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Crowdfunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }
    
    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns;

    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public {
        require(_deadline > block.timestamp, "The deadline should be a date in the future.");

        Campaign storage campaign = campaigns[numberOfCampaigns];
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;
    }

    function donateToCampaign(uint256 _id) public payable {
        require(msg.value > 0, "Donation amount must be greater than zero.");

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(msg.value);

        if(payable(campaign.owner).send(msg.value)) {
            campaign.amountCollected += msg.value;
        }
    }

    function getCampaign(uint256 _id) public view returns (Campaign memory) {
        return campaigns[_id];
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint256 i = 0; i < numberOfCampaigns; i++) {
            allCampaigns[i] = campaigns[i];
        }

        return allCampaigns;
    }
}
