import Pkg, REPL;

atreplinit() do repl
  if !isdefined(repl, :interface)
    repl.interface = REPL.setup_interface(repl);
  end
  REPL.numbered_prompt!(repl);

  if isfile("Project.toml") || isfile("Manifest.toml")
    Pkg.activate(".");
  end
end
