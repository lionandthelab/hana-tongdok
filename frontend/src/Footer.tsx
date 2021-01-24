import * as React from 'react';
import { Button } from '@material-ui/core';
interface IProps {
    name?: string;
}

const Footer: React.FC<IProps> = (props: IProps) => 
    <div id="Footer">
        <h1>This is Footer</h1>
    </div>

Footer.defaultProps = {
    name: 'world',
};

export default Footer;
