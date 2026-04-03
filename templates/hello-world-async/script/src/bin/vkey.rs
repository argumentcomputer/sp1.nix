use sp1_sdk::{include_elf, Elf, HashableKey, Prover, ProvingKey, ProverClient};

/// The ELF (executable and linkable format) file for the Succinct RISC-V zkVM.
const FIBONACCI_ELF: Elf = include_elf!("fibonacci-program");

#[tokio::main]
async fn main() {
    let client = ProverClient::from_env().await;
    let pk = client.setup(FIBONACCI_ELF).await.expect("failed to setup elf");
    println!("{}", pk.verifying_key().bytes32());
}
