# Changelog

## 0.0.1 (2024-10-06)


### Features

* activate release-please ([#122](https://github.com/chickenandpork/rules_synology/issues/122)) ([f11dab8](https://github.com/chickenandpork/rules_synology/commit/f11dab8b98201ddfaae56a63eeaef714021cbbba))
* Activate stardoc/mkdocs documentation ([a91f58d](https://github.com/chickenandpork/rules_synology/commit/a91f58dac29292b3ea2ae0c16935ccecb52d0d3d))
* add more Synology models ([fc2a8cc](https://github.com/chickenandpork/rules_synology/commit/fc2a8cc733b3fbc23691a2a8969e3e7d4d080e16))
* add tool to generate resized image variants ([dd6a66f](https://github.com/chickenandpork/rules_synology/commit/dd6a66f68d895936ba9299b0fa3aa3b0ac2780a4))
* add toolchain denverton for 7.1.1 ([8a499dd](https://github.com/chickenandpork/rules_synology/commit/8a499dd6333707dd2e921118cced29e53bdad6f9))
* Basic cross-build example ([1d6dc83](https://github.com/chickenandpork/rules_synology/commit/1d6dc8391a28d46adcf1f89ee0756ebea4305ee5))
* build a port-forwarding config and a conf/resource file that refers to it ([4a22730](https://github.com/chickenandpork/rules_synology/commit/4a227307dbccf8793512a53443460e5b341f643a))
* build the SPK as a tarball ([efa5877](https://github.com/chickenandpork/rules_synology/commit/efa5877ed30ce11f8bfff8ac9f756f1e794eb3b1))
* bump go toolchain 1.19.5 -&gt; 1.22.4 to permit newer rulesets ([f37f057](https://github.com/chickenandpork/rules_synology/commit/f37f05778d0f654ae0e578e132d23f7df9f118c2))
* bzlmodify ([8f712ff](https://github.com/chickenandpork/rules_synology/commit/8f712fff6a68ab26a58ff95bc396ec983250e952))
* define/example notion of an INFO file ([dd05462](https://github.com/chickenandpork/rules_synology/commit/dd054627864a6d1aad36d46f1e34fa0720bc409f))
* demonstrate packaging up pre-built kernel mods from remote asset ([91e967d](https://github.com/chickenandpork/rules_synology/commit/91e967d890460d759e09e3aa8605c74b9e15ccc0))
* enable armada37xx toolchain ([8374f23](https://github.com/chickenandpork/rules_synology/commit/8374f239e444acd9196388574cafaa16c67eea05))
* ensure example(s) build and unittest ([3971fc7](https://github.com/chickenandpork/rules_synology/commit/3971fc70e0ddb6ce6ad3ff022f18d04dbdf4f890))
* expand basic server example ([181c1ab](https://github.com/chickenandpork/rules_synology/commit/181c1ab553e5852b4491f4f32f50f8950eb4dede))
* expose a Synology Usr-Local-Linker resource ([994b1ec](https://github.com/chickenandpork/rules_synology/commit/994b1ec2f6d3e143682637620c7975ca25f3e613))
* further simplify dependents' use-cases ([7ca6deb](https://github.com/chickenandpork/rules_synology/commit/7ca6debee47a5c1840eb50b0b28a8c53d9ef158c))
* Generate lists of supported DSM, Models, Arch ([2b3149a](https://github.com/chickenandpork/rules_synology/commit/2b3149ab083686819a98d5e657515626068f4108))
* Packaging: development scaffold / test example ([b5de643](https://github.com/chickenandpork/rules_synology/commit/b5de643ed8618cb1e91232569467188c889b16e2))
* provide SSS script stub with actions ([b167cd7](https://github.com/chickenandpork/rules_synology/commit/b167cd700db51afb375f056b850c20458fdb3a86))
* quieter by  a verbosity option ([470e80d](https://github.com/chickenandpork/rules_synology/commit/470e80d547a98291d7a64d1cf3a5e2269462ce2c))
* script to confirm crosstool selection ([9d136c7](https://github.com/chickenandpork/rules_synology/commit/9d136c7a0b8a795056201ed801ee18db48bd79ee))
* script to confirm crosstool selection ([37108a2](https://github.com/chickenandpork/rules_synology/commit/37108a2318bfd1df3f9a92642df0674ebef81bb7))
* simplify dependent MODULE.bazel ([b6af841](https://github.com/chickenandpork/rules_synology/commit/b6af841de1a5ba9a6be6af2f7005f4e45c5d4b28))
* simplify the import/usage effort ([fc34121](https://github.com/chickenandpork/rules_synology/commit/fc34121516d7920c7c369567eff635139da2c1ca))
* simplify the validation of a cross-build binary ([e0ef264](https://github.com/chickenandpork/rules_synology/commit/e0ef264597358a15ce1e6183b908ca8b0be020e1))
* split DSM version from model/arch ([b5325d7](https://github.com/chickenandpork/rules_synology/commit/b5325d7ed7a5f1e0b914dcb9db20857aa1e8a32c))


### Bug Fixes

* all use the same [@rules](https://github.com/rules)_synology path ([71e0ff3](https://github.com/chickenandpork/rules_synology/commit/71e0ff34ec011c3034a1c7a0206edad584103cad))
* Automate any go.mod updates ([9fe08fa](https://github.com/chickenandpork/rules_synology/commit/9fe08fad81bf6192aa0ea62cc42a4c8b3c27d9a0))
* Automerge is too eager, needs to wait for check_suite to succeed ([3f42f10](https://github.com/chickenandpork/rules_synology/commit/3f42f1032fa2050d99b21c8dde69e9aa2bd0f3a2))
* clean up errant softlink (convenience link to source-forest) ([8147c68](https://github.com/chickenandpork/rules_synology/commit/8147c684cb93ad28f476f2876e5e28f2bf82bf81))
* clean up netfilter-mods package based on install experience ([6ece7a6](https://github.com/chickenandpork/rules_synology/commit/6ece7a6a8e46eebcaa608ef706db9fa542789e9f))
* correct file pattern for golines and it works ([f17c598](https://github.com/chickenandpork/rules_synology/commit/f17c598773ccadf622d0b0c204d2ef52c6481ece))
* correct PR [#92](https://github.com/chickenandpork/rules_synology/issues/92) ([523056b](https://github.com/chickenandpork/rules_synology/commit/523056b82725b7165247b48584258194ed78b167))
* ignore in examples, and include the toolchains repos ([d56b65a](https://github.com/chickenandpork/rules_synology/commit/d56b65a952addf8eebc000f4a28743a88a0b039c))
* register_toolchains unavailable outside WORKSPACE (and takes varargs, not a [list]) ([2e82d7e](https://github.com/chickenandpork/rules_synology/commit/2e82d7ef01d0c642906fda55779f47909c091128))
* reinstate removed test dirs ([341b801](https://github.com/chickenandpork/rules_synology/commit/341b8013797ba2ec82166b51e3b5334d9c058df2))
* revert [#92](https://github.com/chickenandpork/rules_synology/issues/92) ([830f802](https://github.com/chickenandpork/rules_synology/commit/830f8024a58afa5dbb38b9fa051a6f7fac7a4ae6))
* use hyphens: we are not doing python yet so no worries ([ad4faf8](https://github.com/chickenandpork/rules_synology/commit/ad4faf8acf65b600ec5d8056c904ef9973863bd0))


### Miscellaneous Chores

* release 0.0.1 ([173b4f1](https://github.com/chickenandpork/rules_synology/commit/173b4f15ad4bcf1818e42c0ac3464c1c3d16a27d))
