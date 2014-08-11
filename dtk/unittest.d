module dtk.unit_test;

import dtk.tclserver;

void main()
{
  auto server = new TclServer();
  assert("3" == server.gets(cast(string)"expr {1+2}"));
  delete(server);
}