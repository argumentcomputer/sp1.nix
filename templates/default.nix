rec {
  hello-world = {
    path = ./hello-world-async;
    description = "Hello World (Async)";
  };
  hello-world-blocking = {
    path = ./hello-world-blocking;
    description = "Hello World (Blocking)";
  };
  default = hello-world;
}
