#define WeakifyAs(strong, weak) __weak typeof(strong) weak = strong;

#define WeakifySelf() WeakifyAs(self, weakSelf);

#define CI_UNAVAILABLE(message) __attribute__((unavailable(message)));

#define InvokeBlock(block, ...) if (block) block(__VA_ARGS__)