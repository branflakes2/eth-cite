pragma solidity ^0.4.0;

contract Primary {
    address public author; //wallet/contract address of the author
    address[] public cited_by; //articles this article is cited in debating
                               //wheter this should be abled to be edited by
                               //author (to remove bogus citations)
    string public reference;
    bytes32 public digest;
    string public auxileryData;
    bool init;
    
    function Primary        (   
                                string ref,
                                bytes32 dig,
                                string aux
                            ) public
    {   
        reference = ref;
        digest = dig;
        author = msg.sender;
        auxileryData = aux;
    }
    
    function AddCitedBy (
                            address article
                        ) external initialized returns (bool success) {
        cited_by.push(article);
        return true;
    }
    
  /*  function CheckAcceptable(
                                uint currentUpdates,
                                uint maxUpdates) internal returns (int upds) {
        uint prospectiveUpdates = 0;
        for(uint i = 0; i < cited_by.length; i++){
            prospectiveUpdates++;
            if(prospectiveUpdates > maxUpdates){
                return -1;
            }
        }
        for(uint i = 0; i < cited_by.length;)
    }*/
    
    modifier onlyAuthor {
        require(msg.sender == author);
        _;
    }
    
    //allow other articles to add citations
    modifier initialized{
        require(init == true);
        _;
    }
}

contract Article is Primary{
    
    address[] public citations; //citations made by this article
    bool private init; //makes sure all cited articles are properly notified
    
    function    Article     (
                                string ref,
                                bytes32 dig,
                                string aux,
                                address[] cits
                            )   
                Primary     (   
                                ref,
                                dig,
                                aux
                            ) public {
        citations = cits;                 
        init = false;
    }
    
    //Causes articles with many transactions to be expensive
    function NotifyCitations    () external onlyAuthor {
        for (uint i = 0; i < citations.length; i++){
            Article a = Article(citations[i]);
            a.AddCitedBy(this);
        }
        init = true;
    }
    
    
}
