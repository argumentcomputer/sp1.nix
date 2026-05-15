{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  openssl,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-prove";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "succinctlabs";
    repo = "sp1";
    rev = "v${version}";
    hash = "sha256-0f8aHrrsMVml+prEK5jXrjYSkVgE17KD0pBeeV3d7O8=";
  };

  cargoHash = "sha256-M6lKVu4Vx6jo++6pU3V9Jm+1yanWHOj4tdXyQRbxrBA=";

  buildAndTestSubdir = "crates/cli";

  # The runner crate's build script spawns a nested `cargo build` to produce a
  # helper binary it then embeds. Under `buildRustPackage` the outer build sets
  # `--target <host-triple>`, which the nested invocation inherits via
  # `CARGO_BUILD_TARGET`. That places the binary under
  # `target/<triple>/release/` while the script looks for it at
  # `target/release/`. Clear the env vars in the nested invocation so the path
  # matches.
  postPatch = ''
    substituteInPlace crates/core/runner/build.rs \
      --replace-fail 'cmd.env_remove("RUSTFLAGS");' \
        'cmd.env_remove("RUSTFLAGS"); cmd.env_remove("CARGO_BUILD_TARGET"); cmd.env_remove("CARGO_BUILD_TARGET_DIR");'
  '';

  # Tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    description = "CLI for SP1, a performant zkVM";
    homepage = "https://github.com/succinctlabs/sp1";
    license = with licenses; [mit asl20];
    maintainers = [];
    mainProgram = "cargo-prove";
  };
}
