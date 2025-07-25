module impatient::coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::url::{Self, Url};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::option;

    // Define the coin struct that can store value
    public struct DEV$MGTToken has key, store { value: u64 }

    // Initialize the module and create the currency
    fun init(witness: DEV$MGTToken, ctx: &mut TxContext) {
        // Create a URL for the coin's icon
        let icon_url = url::new_unsafe_from_bytes(b"https://framerusercontent.com/images/0KKocValgAmB9XHzcFI6tALxGGQ.jpg");
        let decimals: u8 = 8; // u* is invalid; use u8 for decimals

        // Fixed multiplier for 8 decimals (10^8)
        let multiplier = 100000000;

        // Create the currency with metadata
        let (mut treasury_cap, metadata) = coin::create_currency(
            witness,
            decimals,
            b"DEV$MGT",          // Symbol
            b"DEV$MGT ON SUI",   // Name
            b"DEV$MGT Learnt Sui. Proof proof", // Description
            option::some(icon_url), // Icon URL as an option
            ctx
        );

        // Mint 900 tokens (adjusted by multiplier for decimals)
        let initial_coins = coin::mint(&mut treasury_cap, 900 * multiplier, ctx);
        transfer::public_transfer(initial_coins, tx_context::sender(ctx));

        // Freeze the metadata to prevent modifications
        transfer::public_freeze_object(metadata);

        // Transfer the treasury cap to the sender
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
    }

    // Function to mint new tokens
    public entry fun mint(
        treasury_cap: &mut TreasuryCap<DEV$MGTToken>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        // Mint the specified amount of coins
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient);
    }
}