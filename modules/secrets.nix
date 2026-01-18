{ config, ... }: {
  # agenix uses your SSH key to decrypt secrets
  age.identityPaths = [ "/Users/bradford/.ssh/id_ed25519" ];

  # Add secrets here like:
  # age.secrets.some-api-key = {
  #   file = ../secrets/some-api-key.age;
  #   owner = "bradford";
  #   mode = "600";
  # };
}
