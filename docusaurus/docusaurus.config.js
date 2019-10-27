/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

module.exports = {
  title: 'Docusaurus.Powershell',
  tagline: 'Awesome documentation for Powershell Modules',
  url: 'https://docusaurus-powershell.netlify.com/',
  baseUrl: '/',
  favicon: 'img/favicon.ico',
  organizationName: 'alt3', // Usually your GitHub org/user name.
  projectName: 'Docusaurus.Powershell', // Usually your repo name.
  themeConfig: {
    navbar: {
      title: 'Docusaurus.Powershell',
      logo: {
        alt: 'My Site Logo',
        src: 'img/logo.svg',
      },
      links: [
        {to: 'docs/introduction', label: 'Docs', position: 'right'},
        {
          href: 'https://github.com/alt3/Docusaurus.Powershell',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Introduction',
              to: 'docs/introduction',
            },
            {
              label: 'Installation',
              to: 'docs/installation',
            },
            {
              label: 'Usage',
              to: 'docs/usage',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Discord',
              href: 'https://discordapp.com/invite/docusaurus',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Github',
              href: 'https://github.com/alt3/Docusaurus.Powershell',
            },
          ],
        },
      ],
      copyright: `Copyright ©${new Date().getFullYear()} ALT3 B.V.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js')
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
