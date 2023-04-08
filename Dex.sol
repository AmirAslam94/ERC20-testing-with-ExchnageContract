//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import "../contracts/wallet.sol";

contract Dex is wallet{

    enum Side {
        SELL,
        BUY 
    }
    
    Order[] public buyOrders;
    Order[] public sellOrders;

    struct Order {
        uint id;
        address  trader;
        Side side;
        bytes32 ticker;
        uint amount;
        uint price;
    }
   
    mapping(bytes32 => mapping(uint => Order[])) public orderBook;

    function getOrderBook(bytes32 ticker, Side side) view public returns(Order[] memory) {
        return orderBook[ticker][uint(side)];
    }
    function BuyOrder(bytes32 ticker, uint amount, uint price) public {
        require(tokenMapping[ticker].tokenAddress != address(0), "token not listed"); // checked token is listed
        buyOrders.push(Order(buyOrders.length, msg.sender, Side.BUY, ticker, amount, price));
        orderBook[ticker][uint(Side.BUY)] = buyOrders ;

    }
    function SellOrder(bytes32 ticker, uint amount, uint price) public {
        require(tokenMapping[ticker].tokenAddress != address(0), "token not listed");
        require(balances[msg.sender][ticker] >= amount, "tokenBalance not available"); // checked user balance in walletContract
        sellOrders.push(Order(sellOrders.length, msg.sender, Side.SELL, ticker, amount, price));
        orderBook[ticker][uint(Side.SELL)] = sellOrders ;

    }

    // function placeOrder () public {
    //     for(uint i = 0; i < buyOrders.length && i < sellOrders.length ; i++){
    //         if(buyOrders[i].price == sellOrders[i].amount) {
    //             address _buyerAdd = buyOrders[i].trader ;
    //             bytes32 _buyerTicker = buyOrders[i].ticker; 
    //             uint256 _buyerAmount = buyOrders[i].amount ;
    //             uint256 _buyPrice = buyOrders[i].price;
    //             address _sellAdd = sellOrders[i].trader;
    //             bytes32 _sellTicker = sellOrders[i].ticker;
    //             uint256 _sellAmount = sellOrders[i].amount;
    //             // uint256 _sellPrice = sellOrders[i].price;
    //             balances[_buyerAdd][_sellTicker] += _sellAmount ;
    //             balances[_buyerAdd][_buyerTicker] -= _buyPrice ;
    //             balances[_sellAdd][_buyerTicker] += _buyerAmount ;
    //             balances[_sellAdd][_sellTicker] -= _buyPrice ;
    //         }
    //     }


    // }



    
  
  
}
