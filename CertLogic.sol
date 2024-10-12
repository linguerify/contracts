// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CertLogic {
    struct Certificate {
        address issuedTo;
        bytes32 certHash;
        uint256 issuedAt;
        bool isValid;
    }

    mapping(bytes32 => Certificate) public certificates;
    address public owner;

    event CertificateIssued(address indexed issuedTo, bytes32 indexed certHash, uint256 issuedAt);
    event CertificateRevoked(bytes32 indexed certHash);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to issue a new certificate
    function issueCertificate(address _to, bytes32 _certHash) public onlyOwner {
        require(certificates[_certHash].issuedAt == 0, "Certificate already exists");

        certificates[_certHash] = Certificate({
            issuedTo: _to,
            certHash: _certHash,
            issuedAt: block.timestamp,
            isValid: true
        });

        emit CertificateIssued(_to, _certHash, block.timestamp);
    }

    // Function to revoke a certificate
    function revokeCertificate(bytes32 _certHash) public onlyOwner {
        require(certificates[_certHash].isValid, "Certificate is not valid");
        certificates[_certHash].isValid = false;

        emit CertificateRevoked(_certHash);
    }

    // Function to verify if a certificate is valid
    function verifyCertificate(bytes32 _certHash) public view returns (bool) {
        return certificates[_certHash].isValid;
    }
}
