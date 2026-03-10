import Pkg, REPL;

atreplinit() do repl
  if !isdefined(repl, :interface)
    repl.interface = REPL.setup_interface(repl);
  end
  REPL.numbered_prompt!(repl);

  if isfile("Project.toml") || isfile("Manifest.toml")
    Pkg.activate(".");
  end

  try
    @eval using OhMyREPL;
    @eval OhMyREPL.colorscheme!("Base16MaterialDarker");
    @eval OhMyREPL.Passes.RainbowBrackets.activate_256colors();
    @eval OhMyREPL.enable_fzf(true);
  catch e
    @warn "Failed to setup OhMyREPL" e;
  end

  try
    @eval using Revise;
  catch e
    @warn "Failed to setup Revise" e;
  end
end
