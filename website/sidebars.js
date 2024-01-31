/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
import commands from "./docs/commands/docusaurus.sidebar.js";

export default {
  docs: {
    'Docs': [
      'introduction',
      'installation',
      'usage',
      'contributing',
      'gallery',
    ],
    'F.A.Q.': [
      'faq/multi-line-examples',
      'faq/multiple-modules',
      'faq/monolithic-modules',
      'faq/search',
      'faq/ci-cd',
      'faq/vendor-agnostic',
    ],
    "Get-Help": commands,
  },
};
