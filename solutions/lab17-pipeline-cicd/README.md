# ✅ Solution — Lab 17 : Terraform dans un pipeline DevOps

Ce dossier correspond à la **racine du dépôt GitHub** `tf-pipeline-<identity>` de l'étudiant. Copiez son contenu dans votre dépôt, puis remplacez `<identity>` dans `infra/terraform.tfvars`.

> Les workflows de ce dossier ne s'exécutent pas depuis `terraform_GK` : GitHub n'exécute que les workflows placés à la racine `.github/workflows/` d'un dépôt.

```text
.
├── .github/workflows/
│   ├── terraform.yml      # CI (PR) + CD (main) — TODO 1 et 2 complétés
│   └── destroy.yml        # destruction manuelle — TODO 4 complété
├── infra/
│   ├── backend.tf         # configuration partielle (TFSTATE_RG / TFSTATE_SA)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars   # versionné : aucune valeur secrète
│   └── site/index.html.tftpl
└── .gitignore
```

## Réponses aux TODO

**TODO 1** — étape de validation, entre `init` et `plan` :

```yaml
      - name: terraform validate
        run: terraform validate
```

**TODO 2** — condition du job `apply` :

```yaml
    if: github.ref == 'refs/heads/main' && github.event_name != 'pull_request'
```

**TODO 3** — le tag modifié à la main est une **dérive** : le plan affiche `1 to change` sur `azurerm_resource_group.rg` (`~ tags`), et l'apply remet la valeur du code. Dans un pipeline, **le code Git est la source de vérité** : toute modification manuelle est écrasée au déploiement suivant.

**TODO 4** — condition du job `destroy` :

```yaml
    if: inputs.confirmation == 'detruire'
```

## Réponses aux questions

1. La machine du pipeline est détruite après chaque exécution : un état local serait perdu, et Terraform voudrait tout recréer à la fois suivante.
2. Pour appliquer **exactement** ce qui a été relu : un nouveau `plan` pourrait différer si l'état ou Azure a changé entre‑temps (Terraform refuse alors le plan : `Saved plan is stale`).
3. Un secret est chiffré et masqué dans les journaux ; une variable est lisible. Le nom d'un compte de stockage n'est pas confidentiel : sans identifiants, il ne donne accès à rien.
4. Une PR exécute `fmt`, `init`, `validate` et `plan` sans rien modifier. Un push sur `main` ajoute l'`apply` du plan enregistré.
5. Il fige les versions exactes des providers : le pipeline installe les mêmes que le poste du développeur, d'une exécution à l'autre.
