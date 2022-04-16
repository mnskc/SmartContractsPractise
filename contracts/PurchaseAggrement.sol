//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract PurchaseAgreement{
    uint public value;
    address payable public seller;
    address payable public buyer;

    enum State{
        Created,
        Locked,
        Release,
        Inactive
    }

    State public state;

    constructor() payable{
        seller = payable(msg.sender);
        value = msg.value / 2;
    }

    /// The Function cannot be called at the current state.
    error InvalidState();


    /// Only the buyer can call this function
    error OnlyBuyerAllowed();

    /// Only the seller can call this function
    error OnlySellerAllowed();

    modifier inState(State state_){
        if(state != state_){
            revert InvalidState();
        }
        _;
    }

    modifier onlyBuyer(){
        if(msg.sender != buyer){
            revert OnlyBuyerAllowed();
        }
        _;
    }

    modifier onlySeller(){
        if(msg.sender != seller){
            revert OnlySellerAllowed();
        }
        _;
    }

    function confirmPurchase() external inState(State.Created) payable{
        require(msg.value == (2 * value) , "Please send in 2x the purchase amount");
        buyer = payable(msg.sender);
        state = State.Locked;
    }

    function confirmReceived() external inState(State.Locked) onlyBuyer{
        state = State.Release;
        buyer.transfer(value);
    }

    function paySeller() external inState(State.Release) onlySeller{
        state = State.Inactive;
        seller.transfer(3 * value);
        value = 0;
    }

    function abort() external inState(State.Created) onlySeller{
        state = State.Inactive;
        seller.transfer(address(this).balance);
        value = 0;
    }

}