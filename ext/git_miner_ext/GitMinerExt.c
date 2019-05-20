#include "ruby.h"
#include "openssl/sha.h"
#include <stdio.h>
#include <stdbool.h>

VALUE GitMinerExt = Qnil;

void Init_git_miner_ext();

VALUE rb_sha1_hexdigest(VALUE self, VALUE rbString);
VALUE rb_sha1_mine(VALUE self, int authorOffset, int committerOffset, int qty);

void Init_git_miner_ext() {
    GitMinerExt = rb_define_module("GitMinerExt");
    rb_define_method(GitMinerExt, "c_sha1_hexdigest", rb_sha1_hexdigest, 1);
    rb_define_method(GitMinerExt, "c_sha1_mine", rb_sha1_mine, 3);
}

VALUE rb_sha1_hexdigest(VALUE self, VALUE rbString) {
    unsigned char result[SHA_DIGEST_LENGTH];
    const char *string = StringValueCStr(rbString);

    SHA1(string, strlen(string), result);

    unsigned char resultHex[SHA_DIGEST_LENGTH*2 + 1];
    int i = 0;
    for (i = 0; i < SHA_DIGEST_LENGTH; i++) {
        sprintf((char*)&(resultHex[i*2]), "%02x", result[i]);
    }

    printf("ShaGenDebug: %s\n", resultHex);
    return rb_str_new_cstr(resultHex);
}

VALUE rb_sha1_mine(VALUE self, int authorOffset, int committerOffset, int qty) {
    VALUE rbPrefix = rb_iv_get(self, "@prefix");
    char* prefix = StringValueCStr(rbPrefix);

    VALUE rbTimestamp = rb_iv_get(self, "@timestamp");
    long timestamp = FIX2LONG(rbTimestamp);

    VALUE rbGitHeadTree = rb_iv_get(self, "@git_head_tree");
    char* gitHeadTree = StringValueCStr(rbGitHeadTree);

    VALUE rbGitHeadParent = rb_iv_get(self, "@git_head_parent");
    char* gitHeadParent = StringValueCStr(rbGitHeadParent);

    VALUE rbGitHeadAuthorPrefix = rb_iv_get(self, "@git_head_author_prefix");
    char* gitHeadAuthorPrefix = StringValueCStr(rbGitHeadAuthorPrefix);

    VALUE rbGitHeadCommitterPrefix = rb_iv_get(self, "@git_head_committer_prefix");
    char* gitHeadCommitterPrefix = StringValueCStr(rbGitHeadCommitterPrefix);

    VALUE rbGitHeadMessage = rb_iv_get(self, "@git_head_message");
    char* gitHeadMessage = StringValueCStr(rbGitHeadMessage);

    // TODO: init required or not?
    int space = 10000;
    char currentHead[space];
    char commitPrefix[space];
    char currentCommit[space];
    for(int i = 0; i < space; i++) {
        currentHead[i] = '\0';
        commitPrefix[i] = '\0';
        currentCommit[i] = '\0';
    }

    unsigned char currentSha[SHA_DIGEST_LENGTH];
    unsigned char currentHex[SHA_DIGEST_LENGTH*2 + 1];

    int shaLen;

    for(int i = 0; i < qty; i++) {
        sprintf(currentHead, "%s%s%s%d +0000\n%s%d +0000\n%s",
            gitHeadTree,
            gitHeadParent,
            gitHeadAuthorPrefix,
            timestamp - authorOffset,
            gitHeadCommitterPrefix,
            timestamp - committerOffset,
            gitHeadMessage
        );

        sprintf(commitPrefix, "commit %d", strlen(currentHead));
        sprintf(currentCommit, "%s_%s", commitPrefix, currentHead);
        currentCommit[strlen(commitPrefix)] = '\0';

        shaLen = strlen(commitPrefix) + 1 + strlen(currentHead);
        SHA1(currentCommit, shaLen, currentSha);

        for (int j = 0; j < SHA_DIGEST_LENGTH; j++) {
            sprintf((char*)&(currentHex[j*2]), "%02x", currentSha[j]);
        }

        int prefixLen = strlen(prefix);
        bool match = true;
        for(int j = 0; j < prefixLen; j++) {
            match = match && (prefix[j] == currentHex[j]);
        }

        if (match) {
            rb_iv_set(self, "@result_current_sha", rb_str_new_cstr(currentHex));
            rb_iv_set(self, "@result_author_offset", LONG2FIX(authorOffset));
            rb_iv_set(self, "@result_committer_offset", LONG2FIX(committerOffset));
            return Qnil;
        }

        committerOffset++;
        if(committerOffset > authorOffset) {
            authorOffset++;
            committerOffset = 0;
        }
    }

    return Qnil;
}
