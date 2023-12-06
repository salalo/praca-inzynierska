// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Crowdfunding {
    struct Campaign {
        string title;
        string description;
        string imageHash;
        uint256 goalAmount;
        uint256 currentAmount;
        uint256 deadline;
        bool isComplete;
        address beneficiary;
        address[] contributors;
        uint256[] contributions;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public campaignsCount = 0;

    function createCampign(
        address _beneficiary,
        string memory _title,
        string memory _description,
        uint256 _goalAmount,
        uint256 _deadline,
        string memory _imageHash
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[campaignsCount];

        require(
            campaign.deadline < block.timestamp,
            "Deadline must be in the future."
        );

        campaign.beneficiary = _beneficiary;
        campaign.title = _title;
        campaign.description = _description;
        campaign.goalAmount = _goalAmount;
        campaign.deadline = _deadline;
        campaign.imageHash = _imageHash;

        campaign.currentAmount = 0;
        campaignsCount++;

        return campaignsCount - 1; // return the index of the campaign
    }

    function donate(uint256 _campaignId) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_campaignId];

        campaign.contributors.push(msg.sender);
        campaign.contributions.push(amount);

        (bool sent, ) = payable(campaign.beneficiary).call{value: amount}("");

        if (sent) {
            campaign.currentAmount += amount;
        }
    }

    function getContributors(
        uint256 _campaignId
    ) public view returns (address[] memory, uint256[] memory) {
        return (
            campaigns[_campaignId].contributors,
            campaigns[_campaignId].contributions
        );
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](campaignsCount);

        for (uint256 i = 0; i < campaignsCount; i++) {
            allCampaigns[i] = campaigns[i];
        }

        return allCampaigns;
    }
}
