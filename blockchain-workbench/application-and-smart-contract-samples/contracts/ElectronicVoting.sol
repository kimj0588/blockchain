pragma solidity >=0.4.25 <0.6.0;

contract ElectronicVoting{
    enum StateType {ActiveVoter,Person_Verified,Biometrics_Verified,Aadhar_Verified,TimeOut,Vote_Casted} 
    address public Voter;
    address public Physical_Verifier;
    address public Biometric_Verifier;
    address public AadharandVoterId_Verifier;
    address public Timeout_Checker;

    //the initials requirements of voter
    string public Description;
    string public Name_of_the_voter;
    string public DOB;
    string public Aadhar;
    string public VoterID;
    string public StartTimer;
    string private Vote;

    //States
    StateType public State;

    constructor (string memory description,string memory name,
     string memory dob,string memory aadhar,string memory voterid,string memory starttime) public{
        Voter = msg.sender;
        Description = description;
        Name_of_the_voter = name;
        DOB = dob;
        Aadhar = aadhar;
        VoterID = voterid;
        StartTimer = starttime;

        State = StateType.ActiveVoter;
    }

    function Modify(string memory aadhar,string memory name,string memory dob,string memory voterid) public{
        DOB = dob;
        Aadhar = aadhar;
        VoterID = voterid;
        Name_of_the_voter = name;
    }

    function compareStrings (string memory a, string memory b) public view 
        returns (bool) {return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );}

    function physicalValidator(address InstanceVoter,address InstancePhysical_Verifier,string memory name,
     string memory dob,string memory aadhar,string memory voterid) public{
        if(State != StateType.ActiveVoter)
        {
            revert("not in the initial state");
        }
        if(InstanceVoter != msg.sender){
            revert("role changed");
        }
        if(!(InstancePhysical_Verifier!=Physical_Verifier)){
            Physical_Verifier = msg.sender;
        }
        if(!(compareStrings(dob,DOB)&&compareStrings(aadhar, Aadhar)&&compareStrings(voterid,VoterID))){
            revert("details don't match from record");
        }

        State = StateType.Person_Verified;
    }

    function BiometricValidator(address InstanceVoter) public{
        if(State != StateType.Person_Verified){
            revert("Person not verified");
        }
        if(InstanceVoter != msg.sender){
            revert("only physical verifier can verify");
        }
        State = StateType.Biometrics_Verified;
    }

    function AadharScan(address voter,string memory aadhar) public{
        if(State != StateType.Biometrics_Verified){
            revert("Person not Biometrified");
        }
        if(!(compareStrings(aadhar, Aadhar))){
            revert("details do not match");
        }
        State = StateType.Aadhar_Verified;
    }

    function CastedVoteChecker(string memory Party) public{
        if(State != StateType.Biometrics_Verified){
            Vote = Party;
        }
    }

    function TimeoutChecker(string memory startTime, string memory MAX_TIME) public{
        revert(startTime);
    }
}