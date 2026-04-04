{
  perSystem =
    { pkgs, ... }:
    let
      generate = pkgs.writers.writePython3Bin "generate" { libraries = [ ]; } ''
        import os
        import re
        import sys
        import shutil

        TEMPLATES_PATH = "${../../templates}"


        def show_help():
            print("Usage:")
            print("  generate <template> <target-dir> [<key>=<value> ...]")
            print("  generate list")
            print("\nArguments:")
            print("  <template>           Name of the template")
            print("  <target-dir>         Directory to generate into")
            print("  [<key>=<value> ...]  One or more substitution variables")
            print("\nPlaceholders:")
            print("  {{key}}         Raw                   e.g. my lib")
            print("  {{key:f}}       flatcase              e.g. mylib")
            print("  {{key:s}}       snake_case            e.g. my_lib")
            print("  {{key:k}}       kebab-case            e.g. my-lib")
            print("  {{key:c}}       camelCase             e.g. myLib")
            print("  {{key:P}}       PascalCase            e.g. MyLib")
            print("  {{key:H}}       Headercase            e.g. Mylib")
            print("  {{key:S}}       SCREAMINGCASE         e.g. MYLIB")
            print("  {{key:TS}}      Title_Snake_Case      e.g. My_Lib")
            print("  {{key:Hs}}      Header_snake_case     e.g. My_lib")
            print("  {{key:TK}}      Title-Kebab-Case      e.g. My-Lib")
            print("  {{key:Hk}}      Header-kebab-case     e.g. My-lib")
            print("  {{key:SS}}      SCREAMING_SNAKE_CASE  e.g. MY_LIB")
            print("  {{key:SK}}      SCREAMING-KEBAB-CASE  e.g. MY-LIB")
            print("  \\{{key}}        Literal {{key}}")


        def parse_template_meta(meta_path):
            desc = ""
            params = []
            with open(meta_path) as f:
                for line in f:
                    line = line.strip()
                    m = re.match(r'^description = "(.+)"$', line)
                    if m:
                        desc = m.group(1)
                    m = re.match(r"^params = \[(.+)\]$", line)
                    if m:
                        params = [
                            p.strip().strip('"') for p in m.group(1).split(",")
                        ]
            return desc, params


        def derive_variants(k, v):
            base = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", v)
            base = base.replace("_", " ").replace("-", " ")
            base = base.lower()
            base = re.sub(r" +", " ", base).strip()
            words = base.split()

            flat = "".join(words)
            kebab = "-".join(words)
            snake = "_".join(words)
            title_s = "_".join(w.capitalize() for w in words)
            title_k = "-".join(w.capitalize() for w in words)
            pascal = "".join(w.capitalize() for w in words)
            camel = pascal[0].lower() + pascal[1:] if pascal else ""
            header = flat.capitalize()
            scream = flat.upper()
            scream_s = "_".join(w.upper() for w in words)
            scream_k = "-".join(w.upper() for w in words)

            h_s_suffix = "_" + "_".join(words[1:]) if len(words) > 1 else ""
            header_s = words[0].capitalize() + h_s_suffix if words else ""

            h_k_suffix = "-" + "-".join(words[1:]) if len(words) > 1 else ""
            header_k = words[0].capitalize() + h_k_suffix if words else ""

            return [
                (f"{k}:f", flat),
                (f"{k}:k", kebab),
                (f"{k}:s", snake),
                (f"{k}:TS", title_s),
                (f"{k}:Hs", header_s),
                (f"{k}:TK", title_k),
                (f"{k}:Hk", header_k),
                (f"{k}:c", camel),
                (f"{k}:P", pascal),
                (f"{k}:H", header),
                (f"{k}:S", scream),
                (f"{k}:SS", scream_s),
                (f"{k}:SK", scream_k),
                (k, v),
            ]


        def replace_in_file(path, rules):
            with open(path) as f:
                content = f.read()
            for key, value in rules:
                placeholder = "{{" + key + "}}"
                content = content.replace(placeholder, value)
            content = re.sub(r"\\(\{\{[^}]*\}\})", r"\1", content)
            with open(path, "w") as f:
                f.write(content)


        def rename_paths(root, rules):
            all_paths = []
            for dirpath, dirnames, filenames in os.walk(root, topdown=False):
                for name in filenames:
                    all_paths.append(os.path.join(dirpath, name))
                for name in dirnames:
                    all_paths.append(os.path.join(dirpath, name))
            for key, value in rules:
                placeholder = "{{" + key + "}}"
                new_paths = []
                for path in all_paths:
                    if placeholder in path:
                        new_path = path.replace(placeholder, value)
                        os.makedirs(os.path.dirname(new_path), exist_ok=True)
                        shutil.move(path, new_path)
                        new_paths.append(new_path)
                    else:
                        new_paths.append(path)
                all_paths = new_paths


        def remove_empty_dirs(root):
            for dirpath, _, _ in os.walk(root, topdown=False):
                if dirpath == root:
                    continue
                try:
                    os.rmdir(dirpath)
                except OSError:
                    pass


        def cmd_list():
            print("Templates:")
            for name in sorted(os.listdir(TEMPLATES_PATH)):
                tpath = os.path.join(TEMPLATES_PATH, name)
                if not os.path.isdir(tpath):
                    continue
                meta = os.path.join(tpath, ".template")
                if os.path.isfile(meta):
                    desc, params = parse_template_meta(meta)
                    print(f"  {name}")
                    print(f"    description: {desc}")
                    print(f"    params:      {', '.join(params)}")
                else:
                    print(f"  {name}")


        def cmd_generate(template_name, target_dir, kvargs):
            template_path = os.path.join(TEMPLATES_PATH, template_name)
            if not os.path.isdir(template_path):
                print(f"[!] Template '{template_name}' not found")
                sys.exit(1)

            if target_dir != "." and os.path.exists(target_dir):
                print(f"[!] Target '{target_dir}' already exists")
                sys.exit(1)

            meta_path = os.path.join(template_path, ".template")
            if os.path.isfile(meta_path):
                _, expected = parse_template_meta(meta_path)
                provided = set(kvargs.keys())
                missing = [p for p in expected if p not in provided]
                if missing:
                    for m in missing:
                        print(f"[!] Missing required param: {m}")
                    sys.exit(1)

            if target_dir == ".":
                for item in os.listdir(template_path):
                    if item == ".template":
                        continue
                    s = os.path.join(template_path, item)
                    d = os.path.join(target_dir, item)
                    if os.path.isdir(s):
                        shutil.copytree(s, d)
                    else:
                        shutil.copy2(s, d)
            else:
                shutil.copytree(
                    template_path,
                    target_dir,
                    ignore=shutil.ignore_patterns(".template")
                )

            for dirpath, _, filenames in os.walk(target_dir):
                os.chmod(dirpath, 0o755)
                for fname in filenames:
                    os.chmod(os.path.join(dirpath, fname), 0o644)

            rules = []
            for k, v in kvargs.items():
                rules.extend(derive_variants(k, v))

            for dirpath, _, filenames in os.walk(target_dir):
                for fname in filenames:
                    replace_in_file(os.path.join(dirpath, fname), rules)

            rename_paths(target_dir, rules)
            remove_empty_dirs(target_dir)
            print(f"[+] Generated {template_name} -> {target_dir}")


        def main():
            args = sys.argv[1:]
            if not args:
                show_help()
                sys.exit(0)
            if args[0] == "list":
                cmd_list()
                sys.exit(0)
            if len(args) < 2:
                show_help()
                sys.exit(1)

            template_name = args[0]
            target_dir = args[1]
            kvargs = {}
            for arg in args[2:]:
                if "=" in arg:
                    k, _, v = arg.partition("=")
                    kvargs[k] = v

            cmd_generate(template_name, target_dir, kvargs)


        if __name__ == "__main__":
            main()
      '';
    in
    {
      packages = {
        inherit generate;
      };

      apps.generate = {
        type = "app";
        program = generate;
      };
    };
}
