module dev_mgt::devmgt_coin {

    use sui::coin;
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::address;
    use std::string;

    // Define the coin type
    struct DevMGT has store, copy, drop {}

    // Store minting permission
    struct Cap has key {
        cap: coin::MintCap<DevMGT>,
    }

    // Initialize the coin (only once)
    public entry fun init(ctx: &mut TxContext) {
        let (mint_cap, _) = coin::register::<DevMGT>(
            string::utf8(b"Developer Management Token"),
            string::utf8(b"DevMGT"),
            9,
            ctx
        );
        let cap = Cap { cap: mint_cap };
        transfer::public_transfer(cap, address::sender(ctx));
    }

    // Mint coins (only if you have the Cap)
    public entry fun mint(to: address, amount: u64, cap: &mut Cap, ctx: &mut TxContext) {
        let coins = coin::mint(&cap.cap, amount, ctx);
        transfer::transfer(coins, to);
    }

    // Let users receive DevMGT in their wallet
    public entry fun register_wallet(ctx: &mut TxContext) {
        coin::register_account::<DevMGT>(ctx);
    }
}
