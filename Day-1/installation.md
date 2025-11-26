# Terraform Installation Steps on macOS

1. Check Mac architecture

Command:

```
uname -m
```

Expected results:

* arm64 → Apple Silicon (M1/M2/M3)
* x86_64 → Intel

---

2. Install Homebrew (if not installed)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

3. Add HashiCorp tap

```
brew tap hashicorp/tap
```

---

4. Install Terraform

```
brew install hashicorp/tap/terraform
```

---

5. Verify installation

```
terraform -version
```

You should see something like:

```
Terraform v1.x.x
```