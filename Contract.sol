// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Crowdfunding Contract
/// @dev A simple contract for creating and contributing to crowdfunding campaigns
contract Crowdfunding {
    struct Campaign {
        string title;
        string description;
        address payable creator;
        uint256 goal;
        uint256 pledged;
        uint256 deadline;
    }

    Campaign[] public campaigns;

    event CampaignCreated(uint256 campaignId, address creator);
    event Pledged(uint256 campaignId, address contributor, uint256 amount);

    function createCampaign(string memory _title, string memory _description, uint256 _goal, uint256 _duration) public {
        require(_goal > 0, "Goal must be greater than zero");
        require(_duration > 0, "Duration must be greater than zero");

        campaigns.push(
            Campaign({
                title: _title,
                description: _description,
                creator: payable(msg.sender),
                goal: _goal,
                pledged: 0,
                deadline: block.timestamp + _duration
            })
        );

        emit CampaignCreated(campaigns.length - 1, msg.sender);
    }

    function pledge(uint256 _campaignId) public payable {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp < campaign.deadline, "Campaign has ended");
        require(msg.value > 0, "Must pledge a positive amount");

        campaign.pledged += msg.value;
        emit Pledged(_campaignId, msg.sender, msg.value);
    }

    function getCampaign(uint256 _campaignId) public view returns (Campaign memory) {
        return campaigns[_campaignId];
    }
}
